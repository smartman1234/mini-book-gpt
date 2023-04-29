import { Controller } from "@hotwired/stimulus";
import React from "react";
import { createRoot } from "react-dom/client";
import { Main } from './components/Main';

export default class extends Controller {
  connect() {
    const app = document.getElementById("app");
    createRoot(app).render(<Main />);
  }
}
