module Api
  module V1
    class BaseController < ApplicationController
      before_action :set_resource, only: [:destroy, :show, :update]

      def index
        plural_resource_name = "@#{resource_name.pluralize}"
        resources = resource_class.where(query_params)
                                  .page(page_params[:page])
                                  .per(page_params[:page_size])

        instance_variable_set(plural_resource_name, resources)
        render json: instance_variable_get(plural_resource_name), status: 200
      end

      def show
        render json: get_resource, status: 200
      end

      def create
        set_resource(resource_class.new(resource_params))

        if get_resource.save
          render json: get_resource, status: 201
        else
          render json: get_resource.errors, status: 422
        end
      end

      def update
        if get_resource.update(resource_params)
          render json: get_resource, status: 200
        else
          render json: get_resource.errors, status: 422
        end
      end

      def destroy
        if get_resource.destroy
          head 204
        else
          render json: get_resource.errors, status: 422
        end
      end

      private

        def get_resource
          instance_variable_get("@#{resource_name}")
        end

        def query_params
          return {} unless params[:q]
          params.require(:q).permit!
        end

        def page_params
          params.permit(:page, :page_size)
        end

        def resource_class
          @resource_class ||= resource_name.classify.constantize
        end

        def resource_name
          @resource_name ||= self.params.fetch("resource_name")
        end

        def resource_params
          params.require(resource_name.singularize).permit!
        end

        def set_resource(resource = nil)
          resource ||= resource_class.find(params[:id])
          instance_variable_set("@#{resource_name}", resource)
        end
    end
  end
end
