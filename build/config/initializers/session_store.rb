Rails.application.config.session_store :cookie_store, key: 'guardaloo_session',same_site: :lax, expire_after: 15.minutes

