function scrollb1(list, direction) {
    let scrollAmount = 0;
    let distance = window.screen.width <= 1300 ? window.screen.width : 1300;
    let step = distance / 50;
    let time = 5;
    let e = document.getElementById(list);
    if (e) {
        let slideTimer = setInterval(() => {
            if (direction === "right") {
                e.scrollLeft += step;
            } else {
                e.scrollLeft -= step;
            }
            scrollAmount += step;
            if (scrollAmount >= distance) {
                clearInterval(slideTimer);
            }
        }, time);
    } else {
        console.error(`Element with id ${list} not found`);
    }
}

document.querySelectorAll('.product-list').forEach(container => {
    const listId = container.querySelector('ul').id;
    const leftArrow = container.querySelector('.arrow-left');
    const rightArrow = container.querySelector('.arrow-right');
    if (leftArrow) {
        leftArrow.addEventListener('click', () => scrollb1(listId, 'left'));
    }
    if (rightArrow) {
        rightArrow.addEventListener('click', () => scrollb1(listId, 'right'));
    }
});