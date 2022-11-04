module Curiosity
  # This class allows us to override the default Blacklight UI through its
  # accompanying view file, ./facet_group_component.html.erb
  # See this discussion for why we do the override this way:
  # https://github.com/ViewComponent/view_component/issues/411#issuecomment-1054607727
  class FacetGroupComponent < Blacklight::Response::FacetGroupComponent; end
end
