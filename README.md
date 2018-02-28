# README

## Overview

### What is done

1. Initial app was moved into small API only Rails application. `CsvExporter` was reimplemented in a `/services` folder and can be run via rake task `mraba:import`.
2. `CsvExporter` was broken down into small testable services.
3. Specs were written for a majority components (I left some specs behind intentionally due to lack of time. This task already turned out to be more time consuming than I expected).
4. OOD and some refactoring techniques were used here as much as I could.
5. Some places have comments wich I left to indicate weak places or places which require much more time to refactor.

### What can still be improved

1. Strategies have #add method which contains old logic from test assignment. They must be refactored. Didn't really touch that logic. (Need time)
2. Rubocop warning should be given more love. Now there are plenty of them and some can be skipped. (Need time)
3. More specs should be wirtten especially for strategies. (Need time)

### To run

1. `bundle install`
2. `rails db:migrate`
3. `rspec spec/`
