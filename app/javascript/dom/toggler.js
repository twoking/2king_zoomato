const $panel = $(".panel");
const $toggler = $(".toggler");
const $filterNav = $("#bottom-nav-filter");
const $homeNav = $("#bottom-nav-home");
const $listToggle = $("[data-target=degree-filter]");
const $friendToggle = $("[data-target=friend-filter]");
const $allFriendsToggle = $(".all-friends-toggler");
const $friends = document.querySelectorAll(".friend-filter");
const $triangle = $("#triangle");

// maybe need refactoring

$toggler.on("click", function(e) {
	e.preventDefault();
	const $target = $("#" + this.dataset.target).addClass("active");
	$panel.not($target).removeClass("active");

	if (e.currentTarget === $listToggle[0]) {
		$friendToggle[0].classList.add("text-secondary");
		$friendToggle[0].parentElement.classList.add("btn-home-gray");
		$listToggle[0].classList.remove("text-secondary");
		$listToggle[0].parentElement.classList.remove("btn-home-gray");
	} else {
		$listToggle[0].classList.add("text-secondary");
		$listToggle[0].parentElement.classList.add("btn-home-gray");
		$friendToggle[0].classList.remove("text-secondary");
		$friendToggle[0].parentElement.classList.remove("btn-home-gray");
	}

	$filterNav.removeClass("active");
	$homeNav.addClass("active");
});

$homeNav.on("click", function(e) {
	$filterNav.addClass("active");
	$homeNav.removeClass("active");

	$panel.slice(1).removeClass("active");
	$panel.first().addClass("active");
});

if ($allFriendsToggle) {
	$allFriendsToggle.on("click", e => {
		e.preventDefault();
		$triangle[0].classList.toggle("blue-triangle");

		$friends.forEach(friend => {
			friend.checked = !friend.checked;
		});
	});
}
