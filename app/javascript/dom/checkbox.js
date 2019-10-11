const degreeCheckboxes = document.querySelectorAll(".regular-checkbox");
if (degreeCheckboxes) {
	degreeCheckboxes.forEach(checkbox => {
		if (checkbox.checked) {
			checkbox.nextElementSibling.classList.add("font-weight-bold");
		}

		checkbox.addEventListener("click", e => {
			e.currentTarget.nextElementSibling.classList.toggle("font-weight-bold");
		});
	});
}
