require 'rubygems'
require 'erector'

class Layout < Erector::Widget
  def render
    html do
      head do
        link :rel => "stylesheet",
             :type => "text/css",
             :href => "./screen.css"
      end
      
      body do
        div :id => 'top' do
        end
        div :id => 'middle' do
          div :id => 'content' do
            content
          end
        end
        div :id => 'bottom' do
          
        end
      end
    end    
  end
  
  def bluecloth(path)
    File.open(path) do |file|
      text BlueCloth.new(file.read).to_html
    end
  end
end

class Index < Layout
  def content
    bluecloth "index.markdown"
  end
end

puts Index.new.to_s