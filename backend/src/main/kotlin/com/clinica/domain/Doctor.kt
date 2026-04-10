package com.clinica.domain

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "doctor")
class Doctor(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @Column(name = "first_name", nullable = false, length = 100)
    var firstName: String,

    @Column(name = "last_name", nullable = false, length = 100)
    var lastName: String,

    @Column(nullable = false, length = 150)
    var specialization: String,

    @Column(nullable = false, length = 255)
    var email: String,

    @Column(name = "license_number", nullable = false, unique = true, length = 50)
    var licenseNumber: String,

    @Column(name = "created_at", nullable = false, updatable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),

    @Column(name = "updated_at", nullable = false)
    var updatedAt: LocalDateTime = LocalDateTime.now(),

    @OneToMany(mappedBy = "doctor", cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    val appointments: MutableList<Appointment> = mutableListOf()
) {
    @PreUpdate
    fun onUpdate() {
        updatedAt = LocalDateTime.now()
    }
}
