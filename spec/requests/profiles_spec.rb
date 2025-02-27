# frozen_string_literal: true

require "rails_helper"

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe("/profiles", type: :request) do
  include_context "with_url_shortener"
  include_context "with_elastic"
  # This should return the minimal set of attributes required to create a valid
  # Profile. As you add validations to Profile, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { attributes_for(:profile) }

  let(:invalid_attributes) { attributes_for(:profile, name: nil) }

  describe "GET /index" do
    it "renders a successful response" do
      Profile.create!(valid_attributes)
      get profiles_url
      expect(response).to(be_successful)
    end

    context "with query" do
      context "without elastic" do
        it "renders a successful response" do
          Profile.create!(valid_attributes)
          get profiles_url, params: { query: "some query" }
          expect(response).to(be_successful)
        end
      end

      context "with elastic", vcr: true do
        it "renders a successful response" do
          Profile.create!(valid_attributes)
          get profiles_url, params: { query: "some query", use_es: 1 }
          expect(response).to(be_successful)
        end

        context "without matching records" do
          it "renders a successful response" do
            allow(Profile).to(receive(:pagy_search).and_return([]))
            get profiles_url, params: { query: "some query", use_es: 1 }
            expect(response).to(be_successful)
          end
        end

        context "with blank query", vcr: true do
          it "renders a successful response" do
            allow(Profile).to(receive(:pagy_search).and_return([]))
            get profiles_url, params: { query: "", use_es: 1 }
            expect(response).to(be_successful)
          end
        end
      end
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      profile = Profile.create!(valid_attributes)
      get profile_url(profile)
      expect(response).to(be_successful)
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_profile_url
      expect(response).to(be_successful)
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      profile = Profile.create!(valid_attributes)
      get edit_profile_url(profile)
      expect(response).to(be_successful)
    end
  end

  describe "POST /create" do
    context "with valid parameters", vcr: true do
      it "creates a new Profile" do
        expect do
          post(profiles_url, params: { profile: valid_attributes })
        end.to(change(Profile, :count).by(1))
      end

      it "redirects to the created profile", vcr: true do
        post profiles_url, params: { profile: valid_attributes }
        expect(response).to(redirect_to(profile_url(Profile.last)))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Profile" do
        expect do
          post(profiles_url, params: { profile: invalid_attributes })
        end.to(change(Profile, :count).by(0))
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post profiles_url, params: { profile: invalid_attributes }
        expect(response).to(have_http_status(:unprocessable_entity))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      new_name = Faker::Name.name
      let(:new_attributes) do
        { name: new_name }
      end

      it "updates the requested profile", vcr: true do
        profile = Profile.create!(valid_attributes)
        patch profile_url(profile), params: { profile: new_attributes }
        profile.reload
        expect(profile.name).to(eq(new_name))
      end

      it "redirects to the profile", vcr: true do
        profile = Profile.create!(valid_attributes)
        patch profile_url(profile), params: { profile: new_attributes }
        profile.reload
        expect(response).to(redirect_to(profile_url(profile)))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        profile = Profile.create!(valid_attributes)
        patch profile_url(profile), params: { profile: invalid_attributes }
        expect(response).to(have_http_status(:unprocessable_entity))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested profile", vcr: true do
      profile = Profile.create!(valid_attributes)
      expect do
        delete(profile_url(profile))
      end.to(change(Profile, :count).by(-1))
    end

    it "redirects to the profiles list", vcr: true do
      profile = Profile.create!(valid_attributes)
      delete profile_url(profile)
      expect(response).to(redirect_to(profiles_url))
    end
  end

  describe "PUT /reindex" do
    it "reindexes the requested profile", vcr: true do
      profile = Profile.create!(valid_attributes)
      allow(FetchProfileJob).to(receive(:perform_async).with(profile.id))
      put reindex_profile_url(profile)
      expect(FetchProfileJob).to(have_received(:perform_async).with(profile.id))
    end
  end

  describe "turbo streams" do
    describe "GET /show" do
      it "renders a successful response" do
        profile = Profile.create!(valid_attributes)
        get profile_url(profile, as: :turbo_stream)
        expect(response).to(be_successful)
      end
    end

    describe "POST /create" do
      context "with valid parameters" do
        it "creates a new Profile", vcr: true do
          expect do
            post(profiles_url, params: { profile: valid_attributes }, as: :turbo_stream)
          end.to(change(Profile, :count).by(1))
        end

        context "when it's not the first record" do
          it "returns different stream", vcr: true do
            Profile.create!(attributes_for(:profile))
            expect do
              post(profiles_url, params: { profile: valid_attributes }, as: :turbo_stream)
            end.to(change(Profile, :count).by(1))
          end
        end
      end

      context "with invalid parameters" do
        it "does not create a new Profile" do
          expect do
            post(profiles_url, params: { profile: invalid_attributes }, as: :turbo_stream)
          end.not_to(change(Profile, :count))
        end

        it "renders a 200 response because it's a stream" do
          post profiles_url, params: { profile: invalid_attributes }, as: :turbo_stream
          expect(response).to(be_successful)
        end
      end
    end

    describe "PATCH /update" do
      context "with valid parameters" do
        let(:new_attributes) do
          { name: "New Name" }
        end

        it "updates the requested profile" do
          profile = Profile.create!(valid_attributes)
          patch profile_url(profile), params: { profile: new_attributes }, as: :turbo_stream
          profile.reload
          expect(profile.name).to(eq("New Name"))
        end
      end

      context "with invalid parameters" do
        it "renders a 200 response because it's a stream" do
          profile = Profile.create!(valid_attributes)
          patch profile_url(profile), params: { profile: invalid_attributes }, as: :turbo_stream
          expect(response).to(be_successful)
        end
      end
    end

    describe "PUT /reindex" do
      it "reindexes the requested profile", vcr: true do
        profile = Profile.create!(valid_attributes)
        allow(FetchProfileJob).to(receive(:perform_async).with(profile.id))
        put reindex_profile_url(profile), as: :turbo_stream
        expect(FetchProfileJob).to(have_received(:perform_async).with(profile.id))
      end
    end

    describe "DELETE /destroy" do
      it "destroys the requested profile", vcr: true do
        profile = Profile.create!(valid_attributes)
        expect do
          delete(profile_url(profile), as: :turbo_stream)
        end.to(change(Profile, :count).by(-1))
      end

      context "when it's not the last profile" do
        it "destroys the requested profile and sends different stream", vcr: true do
          Profile.create(attributes_for(:profile))
          profile = Profile.create!(valid_attributes)
          expect do
            delete(profile_url(profile), as: :turbo_stream)
          end.to(change(Profile, :count).by(-1))
        end
      end
    end
  end
end
