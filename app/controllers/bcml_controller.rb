class BcmlController < ApplicationController
	def index
	end

	def parse
		begin
			config = params[:config] || ""
			bcml = Bcml::Bcml::new(config)
			converted = bcml.exec(params[:text])
		rescue
			converted = <<"EOS"
パース中にエラーが発生しました<br>
マルチライナー記法の開きタグと閉じタグの数が一致していない可能性が考えられます。
EOS
		end
		render :text => converted
	end

	def ajax
		@template = params[:template]
		render
	end
end
