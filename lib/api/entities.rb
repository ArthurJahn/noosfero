module API
  module Entities
    class Article < Grape::Entity
      root 'articles', 'article'
      expose :id, :body, :created_at
      expose :title, :documentation => {:type => "String", :desc => "Title of the article"}

      expose :author do |article, options|
        {
          :id => article.author_id,
          :name => article.author_name,
          :icon_url => article.author_custom_image(:icon),
          :minor_url => article.author_custom_image(:minor),
          :portrait_url => article.author_custom_image(:portrait),
          :thumb_url => article.author_custom_image(:thumb),
        }
      end

    end

    class Comment < Grape::Entity
      root 'comments', 'comment'
      expose :body, :title, :created_at, :id

      expose :author do |comment, options|
        {
          :id => comment.author_id,
          :name => comment.author_name,
          :icon_url => comment.author_custom_image(:icon),
          :minor_url => comment.author_custom_image(:minor),
          :portrait_url => comment.author_custom_image(:portrait),
          :thumb_url => comment.author_custom_image(:thumb),
        }
      end

    end

    class User < Grape::Entity
      root 'users', 'user'
      expose :login
    end

    class UserLogin < User
      expose :private_token
    end

  end
end
