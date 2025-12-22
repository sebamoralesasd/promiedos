# Agent Guidelines for Promiedos

## Commands
- **Run all tests**: `bundle exec rspec`
- **Run single test**: `bundle exec rspec spec/path/to/file_spec.rb:LINE_NUMBER`
- **Lint**: `bundle exec rubocop`
- **Lint autofix**: `bundle exec rubocop -a`
- **Server**: `bin/rails server`

## Code Style
- Ruby 3.2.1, Rails 7.0.5
- Use `frozen_string_literal: true` at the top of all Ruby files
- Services should be plain Ruby classes with `#call` or `#execute` methods
- Controllers: Use service objects for business logic; handle exceptions with `rescue` blocks and `report_exception(e)`
- Error handling: Rescue `ActiveRecord::RecordNotFound`, `ActiveRecord::RecordInvalid`, and `StandardError` in controllers
- Models: Keep lean; use `has_many`, `belongs_to`, and validations
- Method length max: 40 lines (per Rubocop config)
- Use string interpolation with double quotes: `"#{variable}"`
- Use SQL carefully with `Arel.sql()` for custom ordering/queries
- Naming: snake_case for files/methods, CamelCase for classes
- No class documentation required (Style/Documentation disabled)
- Routes: Use `resources` with `only:` to restrict actions; use symbols array notation: `only: %i[create new]`
- Imports: Use `require_relative` for local files (e.g., `require_relative '../../lib/report_exception'`)
- Service modules: Use namespaced modules for related services (e.g., `MatchPositionsServices::Create`)

## Performance & Memory
- Avoid `Model.all` - use scoped queries or `find_each` for batch processing
- Use `includes` to avoid N+1 queries
- Puma configured with 2 workers + preload_app for memory efficiency (Copy-on-Write)
- Ruby GC tuned for low memory usage (see Dockerfile for ENV variables)
