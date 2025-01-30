import "@hotwired/turbo-rails"
import "controllers"
document.addEventListener("DOMContentLoaded", function() {
    let toast = document.getElementById("toast");
    if (toast) {
        toast.classList.add("show");
        setTimeout(() => {
            toast.classList.remove("show");
        }, 3000);
    }
  const checkbox = document.querySelector('input[name="user[want_to_create_organisation]"]');
  const newOrgField = document.getElementById("new-organisation-field");
  const check_box = document.getElementById("user_want_to_create_organisation");
  check_box.addEventListener("click", function() {
    if (checkbox.checked) {
      newOrgField.style.display = "block";
    } else {
      newOrgField.style.display = "none";
    }
  });
});



