package com.clinica.domain

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "trainer")
class Trainer(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @Column(name = "first_name", nullable = false, length = 100)
    var firstName: String,

    @Column(name = "last_name", nullable = false, length = 100)
    var lastName: String,

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    var role: TrainerRole,

    @Column(columnDefinition = "TEXT")
    var bio: String? = null,

    @Column(nullable = false, unique = true, length = 255)
    var email: String,

    @Column(name = "created_at", nullable = false, updatable = false)
    val createdAt: LocalDateTime = LocalDateTime.now(),

    @Column(name = "updated_at", nullable = false)
    var updatedAt: LocalDateTime = LocalDateTime.now(),

    @OneToMany(mappedBy = "trainer", cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    val appointments: MutableList<FitnessAppointment> = mutableListOf()
) {
    @PreUpdate
    fun onUpdate() { updatedAt = LocalDateTime.now() }
}
