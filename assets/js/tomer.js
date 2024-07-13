var cancel
var finalTime

export const updateTime = () => {
    const now = Date.now()
    if (finalTime <= now) {
        document.getElementById("time-text").innerHTML = '0'
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

export function startCountdown(newFinalTime) {
    finalTime = newFinalTime
    updateTime()
}

export function showEpoch(remainingEpoch) {
    const newTime = epochToString(remainingEpoch)
    setTimeTextString(newTime)
}

export const setPushCallback = (cb) => {
    console.log("Callback set")
    document.addEventListener("DOMContentLoaded", function() {
        console.log("Document ready")
        document.getElementById("addtime-btn").addEventListener("click", e => {
            console.log("Button pushed")
            cb(e)
        })
    });
}

export const setPushCallback2 = (cb) => {
    console.log("Callback set")
    document.addEventListener("DOMContentLoaded", function() {
        console.log("Document ready")
        document.getElementById("start-btn").addEventListener("click", e => {
            console.log("Button pushed")
            cb(e)
        })
    });
}
