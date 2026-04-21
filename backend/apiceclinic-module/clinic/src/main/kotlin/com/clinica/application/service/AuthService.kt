package com.clinica.application.service

import com.clinica.doors.outbound.database.entities.UserEntity
import com.clinica.doors.outbound.database.repositories.UserRepository
import com.clinica.dto.LoginRequest
import com.clinica.dto.RegisterRequest
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service

@Service
class AuthService {

    @Autowired
    private lateinit var userRepository: UserRepository

    @Autowired
    private lateinit var passwordEncoder: PasswordEncoder

    fun registerUser(registerRequest: RegisterRequest): UserEntity {
        if (userRepository.existsByUsername(registerRequest.username)) {
            throw IllegalArgumentException("Username già esistente")
        }

        if (!registerRequest.email.isNullOrEmpty() && userRepository.existsByEmail(registerRequest.email)) {
            throw IllegalArgumentException("Email già registrata")
        }

        val user = UserEntity(
            username = registerRequest.username,
            password = passwordEncoder.encode(registerRequest.password),
            email = registerRequest.email,
            enabled = true
        )

        return userRepository.save(user)
    }

    fun validateCredentials(loginRequest: LoginRequest): Boolean {
        val user = userRepository.findByUsername(loginRequest.username)
        return user.isPresent && passwordEncoder.matches(loginRequest.password, user.get().password)
    }
}
