// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as Rails from "@rails/ujs"
Rails.start()

import { Application } from "@hotwired/stimulus"
export const application = Application.start()
