const startSpinner = () => {
	const spinner = `
    <div class="loader-container">
      <div class="loader-logo">
        <div class="loader-circle"></div>
      </div>
    </div>
  `;
	document.querySelector("#search-results").innerHTML = spinner;
};

export { startSpinner };
