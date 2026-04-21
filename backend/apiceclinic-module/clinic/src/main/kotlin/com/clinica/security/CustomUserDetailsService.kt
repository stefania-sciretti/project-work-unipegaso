package com.clinica.security

import com.clinica.doors.outbound.database.repositories.UserRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.User
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.core.userdetails.UsernameNotFoundException
import org.springframework.stereotype.Service

@Service
class CustomUserDetailsService : UserDetailsService {

    @Autowired
    private lateinit var userRepository: UserRepository

    override fun loadUserByUsername(username: String?): UserDetails {
        if (username == null) {
            throw UsernameNotFoundException("Username cannot be null")
        }

        val userEntity = userRepository.findByUsername(username)
            .orElseThrow { UsernameNotFoundException("User not found: $username") }

        // Usa il ruolo salvato nel DB; default ROLE_USER se non impostato
        val role = userEntity.role.let {
            if (it.startsWith("ROLE_")) it else "ROLE_$it"
        }

        return User.builder()
            .username(userEntity.username)
            .password(userEntity.password)
            .disabled(!userEntity.enabled)
            .authorities(listOf(SimpleGrantedAuthority(role)))
            .build()
    }
}
