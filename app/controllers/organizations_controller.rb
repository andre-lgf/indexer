# frozen_string_literal: true

class OrganizationsController < ApplicationController
  # GET /organizations or /organizations.json
  def index
    @pagy, @organizations = pagy(organizations.load_async, items: 10)
  end

  def show
    @organization = Organization.find(params[:id])
  end

  private

  def organizations
    relation = Organization.all
    return relation unless query

    relation.where("name ILIKE :term", term: "%#{query}%")
  end
end
