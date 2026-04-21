package com.clinica.doors.inbound.routes.controller

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.web.bind.annotation.*

/**
 * Debug controller per test e diagnostica (dev only)
 * Endpoint per generare BCrypt hash e verificare password
 */
@RestController
@RequestMapping("/api/debug")
class DebugController {

    @Autowired
    private lateinit var passwordEncoder: PasswordEncoder

    /**
     * Genera l'hash BCrypt di una password
     * POST /api/debug/hash-password?password=admin123
     */
    @PostMapping("/hash-password")
    fun hashPassword(@RequestParam password: String): Map<String, String> {
        val encoded = passwordEncoder.encode(password)
        return mapOf(
            "password" to password,
            "bcrypt_hash" to encoded,
            "raw_command" to "INSERT INTO users (username, password, email, role, enabled) VALUES ('testuser', '$encoded', 'test@example.com', 'ROLE_USER', TRUE);"
        )
    }

    /**
     * Verifica se una password corrisponde a un hash
     * POST /api/debug/verify-password
     * Body: {"password": "admin123", "hash": "$2a$10$..."}
     */
    @PostMapping("/verify-password")
    fun verifyPassword(@RequestBody request: Map<String, String>): Map<String, Any> {
        val password = request["password"] ?: return mapOf("error" to "password required")
        val hash = request["hash"] ?: return mapOf("error" to "hash required")

        val matches = passwordEncoder.matches(password, hash)
        return mapOf(
            "password" to password,
            "hash" to hash,
            "matches" to matches
        )
    }
}
