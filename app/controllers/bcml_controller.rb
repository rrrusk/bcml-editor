class BcmlController < ApplicationController
	def index
	end

	def parse
		config = ""
		bcml = Bcml::Bcml::new(config)
		converted = bcml.exec(params[:text])
		puts converted
		render :text => converted
	end

	def ajax
		@template = params[:template]
		render
	end
end
