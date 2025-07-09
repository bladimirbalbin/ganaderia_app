// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "@rails/ujs"

import { Application } from "@hotwired/stimulus"
export const application = Application.start()
