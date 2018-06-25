(function(window) {

    /**
     * Require: require modules from a virtual file system
     * @param modules -> [ String: String ]
     * @param plugins -> [ (code: String) -> String ]
     */

    window.requireSetup = function requireSetup(modules, plugins = []) {
 
        const evaluated = {}
 
        return function require(name) {
 
            if ( !modules.hasOwnProperty(name) ) {
                throw new Error(`Module ${name} not found`)
            }
 
            // module evaluation
            if ( !evaluated.hasOwnProperty(name) ) {
 
                const content = plugins.reduce(function (sum, fn) {
                    return fn(name, sum)
                }, modules[name])

                const local = {
                    id: name,
                    evaluated: false,
                    exports: {},
                }
 
                try {
                    eval(`(function(module, exports){ ${content} })(local, local.exports)\n\n//# sourceURL=${name}`)
                } catch(err) {
                    err.source = name
                    throw err
                }
 
                evaluated[name] = local
                evaluated[name].evaluated = true
            }
 
            return evaluated[name].exports
        }
    }

    const modules = __MODULES__

    window.require = requireSetup(modules)

    require("__MAIN_ENTRY__")

})(window)
