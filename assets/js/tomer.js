var stop = false
var finalTime

export const updateTime = () => {
    if (stop) {
        return;
    }
    const now = Date.now()
    if (finalTime <= now) {
        document.getElementById("time-text").innerHTML = '0.000'
        return
    }

    const totalMs = finalTime - now

    const newTime = epochToString(totalMs)
    
    setTimeTextString(newTime)

    window.requestAnimationFrame(updateTime)
}

function setTimeTextString(newTime) {
    document.getElementById("time-text").innerHTML = newTime
}

function epochToString(epoch) {
    let hour = Math.floor(epoch / 3_600_000)
    let minute = Math.floor((epoch % 3_600_000) / 60_000)
    let second = Math.floor((epoch % 60_000) / 1_000)
    let ms = epoch % 1000

    let newTime = ''
    if (hour == 0 && minute == 0 && second < 10) {
        newTime = `${second}.${ms.toString().padStart(3, '0')}`
    } else {
        let omit = true
        let displays = [hour, minute, second]
        for (let i = 0; i < displays.length; i++) {
            const value = displays[i]
            if (omit && value == 0) {
                continue
            }

            if (omit) {
                omit = false
                newTime += `${value.toString()}`
            } else {
                newTime += `:${value.toString().padStart(2, '0')}`
            }
        }
    }

    return newTime
}

export function setState(newState) {
  if (newState.type == "pause") {
    showEpoch(newState.remainingEpoch)
  } else if (newState.type == "running") {
    startCountdown(newState.finalTime)
  } else if (newState.type == "standby") {
    standby()
  }
}

function tryHide(elementId) {
    const elem = document.getElementById(elementId)
    if (elem) {
        elem.classList.add("hidden")
    }
}

function tryShow(elementId) {
    const elem = document.getElementById(elementId)
    if (elem) {
        elem.classList.remove("hidden")
    }
}

function startCountdown(newFinalTime) {
    finalTime = newFinalTime
    stop = false
    tryHide("resume-container")
    tryHide("reset-container")
    tryHide("set-container")
    tryShow("pause-container")
    updateTime()
}

function showEpoch(remainingEpoch) {
    stop = true
    const newTime = epochToString(remainingEpoch)
    tryShow("resume-container")
    tryShow("reset-container")
    tryHide("set-container")
    tryHide("pause-container")
    setTimeTextString(newTime)
}

function standby() {
    stop = true
    tryHide("resume-container")
    tryHide("reset-container")
    tryShow("set-container")
    tryHide("pause-container")
    setTimeTextString("0.000")
}

export const setSetCallback = (cb) => {
    console.log("Callback set")
    document.addEventListener("DOMContentLoaded", function() {
        console.log("Document ready")
        const elem = document.getElementById("set-btn")
        if (!elem) {
            return
        }
        elem.addEventListener("click", e => {
            console.log("Button pushed")

            const hour = parseInt(document.getElementById("hour-input").value) || 0
            const minute = parseInt(document.getElementById("minute-input").value) || 0
            const second = parseInt(document.getElementById("second-input").value) || 0

            cb(e, hour, minute, second)
        })
    });
}

export const setResumeCallback = (cb) => {
    console.log("Callback set")
    document.addEventListener("DOMContentLoaded", function() {
        console.log("Document ready")
        const elem = document.getElementById("resume-btn")
        if (!elem) {
            return
        }
        elem.addEventListener("click", e => {
            console.log("Button pushed")
            cb(e)
        })
    });
}

export const setResetCallback = (cb) => {
    console.log("Callback set")
    document.addEventListener("DOMContentLoaded", function() {
        console.log("Document ready")
        const elem = document.getElementById("reset-btn")
        if (!elem) {
            return
        }
        elem.addEventListener("click", e => {
            console.log("Button pushed")
            cb(e)
        })
    });
}

export const setPauseCallback = (cb) => {
    console.log("Callback set")
    document.addEventListener("DOMContentLoaded", function() {
        console.log("Document ready")
        const elem = document.getElementById("pause-btn")
        if (!elem) {
            return
        }
        elem.addEventListener("click", e => {
            console.log("Button pushed")
            cb(e)
        })
    });
}

export const showToast = (e) => {
    Object.keys(e.joins).forEach(join => {
        showJoin(join, e[join])
    })
    Object.keys(e.leaves).forEach(left => {
        showLeave(left, e[left])
    })
}

function showJoin(id, metadata) {
    const div = document.createElement("div")
    div.classList = ["bg-green-800", "p-4", "rounded-lg", "border-green-900", "border-2", "opacity-0", "transition"].join(" ")
    div.innerText = `"${id}" has left the room`
    document.getElementById("toast-list").prepend(div)
    setTimeout(() => {
        div.classList.remove("opacity-0")
    }, 150)
    const remove = () => {
        div.classList.add("opacity-0")
        setTimeout(() => {
            div.remove()
        }, 500)
    }
    div.onclick = () => {
        remove()
    }
    setTimeout(() => {
        remove()
    }, 3000)
}

function showLeave(id, metadata) {
    const div = document.createElement("div")
    div.classList = ["bg-red-800", "p-4", "rounded-lg", "border-red-900", "border-2", "opacity-0", "transition"].join(" ")
    div.innerText = `"${id}" has left the room`
    document.getElementById("toast-list").prepend(div)
    setTimeout(() => {
        div.classList.remove("opacity-0")
    }, 150)
    const remove = () => {
        div.classList.add("opacity-0")
        setTimeout(() => {
            div.remove()
        }, 500)
    }
    div.onclick = () => {
        remove()
    }
    setTimeout(() => {
        remove()
    }, 3000)
}
