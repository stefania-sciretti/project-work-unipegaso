package com.clinica.doors.outbound.database.entities

import jakarta.persistence.*

@Entity
@Table(name = "users")
data class UserEntity(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false, unique = true)
    val username: String = "",

    @Column(nullable = false)
    val password: String = "",

    @Column(nullable = true)
    val email: String? = null,

    @Column(nullable = false)
    val role: String = "ROLE_USER",

    @Column(nullable = false)
    val enabled: Boolean = true
)
