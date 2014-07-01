module SearchHelper

  MAP_SEARCH_LIMIT = 2000
  LIST_SEARCH_LIMIT = 20
  BLOCKS_SEARCH_LIMIT = 24
  MULTIPLE_SEARCH_LIMIT = 8

  SEARCHES = ActiveSupport::OrderedHash[
    :articles, _('Contents'),
    :enterprises, _('Enterprises'),
    :people, _('People'),
    :communities, _('Communities'),
    :products, _('Products and Services'),
    :events, _('Events'),
  ]

  FILTERS_TRANSLATIONS = {
    :order => _('Order'),
    :display => _('Display')
  }

  FILTERS_OPTIONS_TRANSLATION = {
    :order => {
      'more_popular' => _('More popular'),
      'more_active' => _('More active'),
      'more_recent' => _('More recent'),
      'more_comments' => _('More comments')
    },
    :display => {
      'map' => _('Map'),
      'full' => _('Full'),
      'compact' => _('Compact')
    }
  }

  # FIXME remove it after search_controler refactored
  include EventsHelper

  def multiple_search?(searches=nil)
    ['index', 'category_index'].include?(params[:action]) || (searches && searches.size > 1)
  end

  def map_search?(searches=nil)
    !multiple_search?(searches) && params[:display] == 'map'
  end

  def asset_class(asset)
    asset.to_s.singularize.camelize.constantize
  end

  def search_page_title(title, category = nil)
    title = "<h1>" + title
    title += ' - <small>' + category.name + '</small>' if category
    title + "</h1>"
  end

  def category_context(category, url)
    content_tag('div', category.full_name + _(', ') +
        link_to(_('search in all categories'),
          url.merge(:category_path => [], :action => (params[:action] == 'category_index' ? 'index' : params[:action]) )),
      :align => 'center', :class => 'search-category-context') if category
  end

  def display?(asset, mode)
    defined?(asset_class(asset)::SEARCH_FILTERS[:display]) && asset_class(asset)::SEARCH_FILTERS[:display].include?(mode.to_s)
  end

  def display_results(searches=nil, asset=nil)
    if display?(asset, :map) && map_search?(searches)
      partial = 'google_maps'
      klass = 'map'
    else
      partial = 'display_results'
      klass = 'list'
    end

    content_tag('div', render(:partial => partial), :class => "map-or-list-search-results #{klass}")
  end

  def display_filter(asset, display)
    asset = :articles if asset == :tag
    if display?(asset, display)
      display
    else
      asset_class(asset).default_search_display
    end
  end

  def city_with_state(city)
    if city and city.kind_of?(City)
      s = city.parent
      if s and s.kind_of?(State) and s.acronym
        city.name + ', ' + s.acronym
      else
        city.name
      end
    else
      nil
    end
  end

  def select_filter(name, options)
    if options.size <= 1
      return
    else
      options = options.map {|option| [FILTERS_OPTIONS_TRANSLATION[name][option], option]}
      options = options_for_select(options, :selected => params[name])
      select_tag(name, options)
    end
  end

  def filters(asset)
    return if !asset
    klass = asset_class(asset)
    content_tag('div', klass::SEARCH_FILTERS.map do |name, options|
      select_filter(name, options)
    end.join("\n"), :id => 'search-filters')
  end

  def assets_menu(selected)
    assets = SEARCHES.keys
    content_tag('ul',
      assets.map do |asset|
        options = {}
        options.merge!(:class => 'selected') if selected.to_s == asset.to_s
        content_tag('li', asset_link(asset), options)
      end.join("\n"),
    :id => 'assets-links')
  end

  def asset_link(asset)
    link_to(SEARCHES[asset], "/search/#{asset}")
  end

end
