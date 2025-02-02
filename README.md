# asset_viewer

This application helps you organizing and managing your industrial components and
assets. It allows an user-friendly tree visualization of the components. Assets
with subcomponents may be expanded to check the inner details and collapsed after
finishing the check. It also allows filtering by name, energy sensor and critical
status.

## Video of the project running
https://github.com/user-attachments/assets/1dc9b051-ae20-4419-bde0-1a2b7b124754



## Future improvements
- Fix bugs
  - Find a way to add horizontal scroll to avoid pixel overflow caused by the expansion of the tree.
  I did not yet find a way without messing with the vertical line divider that indicates that an
  asset is expanded.
- Improve performance: 
  - caching content from the RestAPI, 
  - caching filters, 
  - improving algorithms
- Refactor the code
- Discuss about the API design:
  - Maybe, it would be interesting to have one endpoint for all the resources (locations, assets and
  components), including a type parameter to make it possible to differentiate them. All of them can
  be considered as resource, but they are collected from different endpoints, requiring multiple 
  http requests.
  - Include the domain of values for 'status' and 'sensorType'. With a specified domain, it would
  be possible to use enums instead of String to represent them during their manipulation.
  - Add a 'type' parameter, making the identification (location, asset and components) much more
  organized, allowing the inclusion of other types of assets in the future without growing the 
  complexity of the ad-hoc rules to identify each one of them. For example, instead of checking if
  a data has the field sensorType, it is easier to check its type. 
- Improve the filtering system, adding more generality, allowing the user to choose any type of 
sensor and status.
  - Use BloC to manage the state of the filter to handle the increase of complexity (for this 
  project, it was not necessary and not allowed)
  - Highlight the matches, specially the string matches
  - Study the possibility to maintain the subtree of any match for string search when there is
  no match with its inner sub elements. With the match highlighting, this feature would satisfy
  the use case of a user that wants to find an intermediate element but also access its inner 
  elements
- Add functionality
  - Add a double tap functionality to expand all the subtree of the double tapped element. The same
  to collapse it.
  - Add a functionality to automatically scroll the page down when new elements are expanded
  - Add a 'Collapse All' button to collapse any expanded element.
  - Study the possibility to add e 'Expand All' functionality
- Improve error handling mechanisms

## Video of the integration test runner

https://github.com/user-attachments/assets/2fc9db8c-f099-4128-b843-2362a7cc0459



## Technical aspects
- "Clean" architecture (three layers): data, domain and user interface.
  - Repositories between data and domain
  - Use cases between domain and user interface
  - Entities != Models
- Time spent: 3 days
- Unit tests and widget tests
- Integration test
- Dependency injection
- Localization
- GitHub Actions pipeline for CI/CD

