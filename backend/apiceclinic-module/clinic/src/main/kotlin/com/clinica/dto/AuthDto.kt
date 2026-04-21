package com.clinica.dto

data class LoginRequest(
    val username: String,
    val password: String
)

data class LoginResponse(
    val accessToken: String,
    val tokenType: String = "Bearer",
    val username: String,
    val role: String = "ROLE_USER"
)

data class RegisterRequest(
    val username: String,
    val password: String,
    val email: String? = null
)
