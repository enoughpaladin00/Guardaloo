# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.3/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"
pin "@rails/ujs", to: "rails-ujs.js"
pin "slider", to: "slider.js" # @1.0.4
pin "index", to: "index.js"
pin "moviePage", to: "moviePage.js"
pin "navbar", to: "navbar.js"
pin "search", to: "search.js"
pin "newpost", to: "newpost.js"
pin "jquery" # @3.7.1
