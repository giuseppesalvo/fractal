/**
 * Catch and send to the app all errors
 * Handler: onConsoleLog
 */

window.onerror = function (message, source, lineno, colno, err) {
    const data = {
        message: err.toString(),
        source: err.source || source,
        lineno: err.line,
        colno: err.column,
        error: JSON.stringify(err)
    }
    window.webkit.messageHandlers.onError.postMessage(
        serialize(data)
    )
}

/**
 * Proxying console log
 * Handler: onConsoleLog
 */

const old_console_log = window.console.log
window.console.log = function () {
    window.webkit.messageHandlers.onConsoleLog.postMessage(serialize(Array.from(arguments)))
    old_console_log(...arguments)
}

/**
 * Proxying console error
 * Handler: onError
 */

const old_console_error = window.console.error
window.console.error = function () {
    window.onerror(Array.from(arguments))
    if ( typeof old_console_error === "function" )
        old_console_error(...arguments)
}

/**
 * Proxying console warn
 * Handler: onWarning
 */

const old_console_warn = window.console.warn
window.console.warn = function () {
    window.webkit.messageHandlers.onWarning.postMessage(serialize(Array.from(arguments)))
    if ( typeof old_console_warn === "function" )
        old_console_warn(...arguments)
}

/**
 * Proxying console clear
 * Handler: onConsoleClear
 */

const old_console_clear = window.console.clear
window.console.clear = function () {
    window.webkit.messageHandlers.onConsoleClear.postMessage(serialize(Array.from(arguments)))
    if ( typeof old_console_clear === "function" )
        old_console_clear(...arguments)
}


