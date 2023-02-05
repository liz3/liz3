const wrapper = document.querySelector(".avatar-wrapper")
wrapper.style.opacity = "0"
const ready = () =>{
    wrapper.style.transition = "opacity 0.5s ease"
    wrapper.style.opacity = "1"
}

const id = Math.floor(Math.random() * 4) + 1;
const path =`./assets/pfp/${id}.png`;
const element = document.createElement("img");
const img = new Image();
img.onload = function() {
    element.src = this.src;
    wrapper.appendChild(element);
    ready();
}
img.src = path;
