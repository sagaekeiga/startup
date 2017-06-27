class EntriesController < ApplicationController

    require 'nokogiri'
    require 'open-uri'
    
    def index
      @q        = Entry.search(params[:q])
      @entries = @q.result(distinct: true).reverse
    end
    
    def new
        @q        = Entry.search(params[:q])
        @entry = Entry.new
    end
    
    def create
     @entry = Entry.new(entry_params)
     if @entry.save
       redirect_to entries_scraping_path(id: @entry.id)
     else
       render 'entries/new'
     end
    end
    
    def edit
      @q        = Entry.search(params[:q])
      @entry = Entry.find(params[:id])
    end
    
    def destroy
      @entry = Entry.find(params[:id])
        if @entry.delete
         flash[:success] = "deleted"
        end
        redirect_to root_path
    end
    
    def update
        @entry = Entry.find(params[:id])
        @entry.update(entry_params)
        redirect_to root_path
    end
    
    def scraping
      @entry = Entry.find_by(id: params[:id])
      doc = Nokogiri::HTML(open("#{@entry.url}"))
              doc.css('img').first(1).each do |img|
                  p @entry[:image] = img[:src] if img[:src].include?("https") || img[:src].include?("http")
               end

              content, title = ExtractContent.analyse(doc.css('div').inner_text)
              p "content"
              p @entry[:content] = content[0...1000].gsub(/[a-zA-Z]/, "").gsub(/\d+/, "")
              .gsub(/\//, "").gsub(/\[/, "").gsub(/\]/, "").gsub(/\(/, "").gsub(/\)/, "").gsub(/\./, "").gsub(/\,/, "")
              .gsub(/\;/, "").gsub(/\:/, "").gsub(/\{/, "").gsub(/\}/, "").gsub(/\¥/, "").gsub(/\~/, "").gsub(/\=/, "")
              .gsub(/\_/, "").gsub(/\#/, "").gsub(/\&/, "").gsub(/\'/, "").gsub(/\"/, "").gsub(/\|/, "").gsub(/\@/, "")
              .gsub(/\>/, "").gsub(/\</, "").gsub(/\-/, "").gsub(/\$/, "").gsub(/\%/, "").gsub(/'/, "").gsub(/\\/, "") + "..."
              p "content"
          @entry.save!
      redirect_to root_path
    end


    

    
      private
      
        def entry_params
          params.require(:entry).permit(:url, :title, :content, :author, :year, :category)
        end
end
