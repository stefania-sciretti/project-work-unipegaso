package com.clinica.repository

import com.clinica.domain.Trainer
import com.clinica.domain.TrainerRole
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface TrainerRepository : JpaRepository<Trainer, Long> {
    fun findByRole(role: TrainerRole): List<Trainer>
}
