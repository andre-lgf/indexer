# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show edit update destroy reindex]

  # GET /profiles or /profiles.json
  def index
    if params[:use_es].to_i == 1
      collection = Profile.pagy_search(query || "*")
      if collection.any?
        @pagy, @profiles = pagy_searchkick(collection, items: 10)
      else
        @profiles = collection
      end
    else
      @pagy, @profiles = pagy(profiles.load_async, items: 10)
    end
  end

  # GET /profiles/1 or /profiles/1.json
  def show
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles or /profiles.json
  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        FetchProfileJob.perform_async(@profile.id)
        format.html { redirect_to(profile_url(@profile), notice: I18n.t("messages.profiles.created")) }
        format.json { render(:show, status: :created, location: @profile) }
        format.turbo_stream do
          flash.now[:notice] = I18n.t("messages.profiles.created")
          if profiles.size.eql?(1)
            render(turbo_stream: [
              turbo_stream.prepend("flash", partial: "layouts/flash"),
              turbo_stream.update("profiles-index", html: render_to_string(::Records::IndexComponent.new(
                collection: profiles,
                resource_model: Profile,
                resource_icon: "user",
              ))),
            ])
          else
            render(turbo_stream: [
              turbo_stream.append("profiles_list", html: render_to_string(::Profiles::ListItemComponent.new(
                profile: @profile,
              ))),
              turbo_stream.prepend("flash", partial: "layouts/flash"),
              turbo_stream.update("new-profile", html: render_to_string(::Forms::NewResourceButtonComponent.new(
                url: new_profile_path,
                resource_name: Profile.normalized_resource,
              ))),
            ])
          end
        end
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @profile.errors, status: :unprocessable_entity) }
        format.turbo_stream do
          flash.now[:error] = @profile.errors.full_messages.join("\n")
          render(turbo_stream: turbo_stream.prepend("flash", partial: "layouts/flash"))
        end
      end
    end
  end

  # PATCH/PUT /profiles/1 or /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to(profile_url(@profile), notice: I18n.t("messages.profiles.updated")) }
        format.json { render(:show, status: :ok, location: @profile) }
        format.turbo_stream do
          flash.now[:notice] = I18n.t("messages.profiles.updated")
          render(turbo_stream: [
            turbo_stream.update("profile_#{@profile.id}-full", html: render_to_string(::Profiles::RecordComponent.new(
              profile: @profile,
            ))),
            turbo_stream.update(@profile, html: render_to_string(::Profiles::ListItemComponent.new(
              profile: @profile,
            ))),
            turbo_stream.prepend("flash", partial: "layouts/flash"),
          ])
        end
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @profile.errors, status: :unprocessable_entity) }
        format.turbo_stream do
          flash.now[:error] = @profile.errors.full_messages.join("\n")
          render(turbo_stream: turbo_stream.prepend("flash", partial: "layouts/flash"))
        end
      end
    end
  end

  # DELETE /profiles/1 or /profiles/1.json
  def destroy
    @profile.destroy!
    Profile.searchkick_index.remove(@profile)
    respond_to do |format|
      format.html { redirect_to(profiles_url, notice: I18n.t("messages.profiles.destroyed")) }
      format.json { head(:no_content) }
      format.turbo_stream do
        flash.now[:notice] = I18n.t("messages.profiles.destroyed")
        if profiles.empty?
          render(turbo_stream: [
            turbo_stream.prepend("flash", partial: "layouts/flash"),
            turbo_stream.update("profiles-index", html: render_to_string(::Records::IndexComponent.new(
              collection: profiles,
              resource_model: Profile,
              resource_icon: "user",
            ))),
          ])
        else
          render(turbo_stream: [
            turbo_stream.remove(@profile),
            turbo_stream.prepend("flash", partial: "layouts/flash"),
          ])
        end
      end
    end
  end

  # PUT /profiles/1/reindex
  def reindex
    FetchProfileJob.perform_async(@profile.id)
    @profile.in_progress!
    respond_to do |format|
      format.html { redirect_to(profile_url(@profile), notice: I18n.t("messages.profiles.reindexing")) }
      format.json { render(:show, status: :ok, location: @profile) }
      format.turbo_stream do
        flash.now[:notice] = I18n.t("messages.profiles.reindexing")
        render(turbo_stream: [
          turbo_stream.update("profile_#{@profile.id}-full", html: render_to_string(::Profiles::RecordComponent.new(
            profile: @profile,
          ))),
          turbo_stream.update(@profile, html: render_to_string(::Profiles::ListItemComponent.new(
            profile: @profile,
          ))),
          turbo_stream.prepend("flash", partial: "layouts/flash"),
        ])
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def profile_params
    params.require(:profile).permit(
      :name, :github_url, :username, :num_followers, :num_following, :num_stars,
      :last_year_contrib, :profile_image_url, :location, :indexing_status
    )
  end

  def profiles
    relation = Profile.all
    return relation unless query

    relation.left_outer_joins(:organizations).where(
      "profiles.name ILIKE :term or username ILIKE :term or location ILIKE :term OR organizations.name ILIKE :term",
      term: "%#{query}%",
    ).distinct
  end
end
