/**
 * Serializing js values to avoid error when calling webkit handlers
 *
 * Just some naive check
 * TODO: normalize everything to a common class
 * Example: class Serialized { type: String, data: Any }
 */

function serialize(data) {
    
    if ( data === null || typeof data === "undefined" || typeof data === "boolean" ) {
        
        return data + ""
        
    } else if ( typeof data === "string" ) {

        return data
    
    } else if ( typeof data === "number" ) {
        
        if ( isNaN(data) || data === Infinity || data === -Infinity ) {
            return data + ""
        }
        
        return data
        
    } else if ( Array.isArray(data) ) {
    
        return data.map(v => {
            return serialize(v)
        })
    
    } else if ( typeof data === "function" ) {
    
        return data.toString()
    
    } else if ( data.constructor.name === "Symbol" ) {
    
        return data.toString()
    
    } else if ( data.constructor.name === "Set" ) {
    
        return "Set(" + Array.from(data).map(v => serialize(v)).join(", ") + ")"
    
    } else if ( data.constructor.name === "Object" ) {
    
        const obj = {}
    
        for ( let k in data ) {
            obj[k] = serialize(data[k])
        }
    
        return obj
    
    } else {
    
        return data.toString ? data.toString() : "" + data
    
    }
}
