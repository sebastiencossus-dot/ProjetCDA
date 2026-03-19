// Attraper les boutons ? burger + croix
const btnBurger = document.querySelector('.NavBox-burger');
const btnClose = document.querySelector('.NavBox-close');

// Attraper le menu de navigation
const navBox = document.querySelector('.NavBox');

// Ajouter un écouteur d'événement au clic sur le bouton burger
btnBurger.addEventListener('click', () => {
    navBox.classList.add('active');
});

// Ajouter un écouteur d'événement au clic sur le bouton croix
btnClose.addEventListener('click', () => {
    navBox.classList.remove('active');
});