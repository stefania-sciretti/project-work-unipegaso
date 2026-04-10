package com.clinica.service

import com.clinica.domain.Trainer
import com.clinica.domain.TrainerRole
import com.clinica.dto.TrainerResponse
import com.clinica.repository.TrainerRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional(readOnly = true)
class TrainerService(private val trainerRepository: TrainerRepository) {

    fun findAll(): List<TrainerResponse> =
        trainerRepository.findAll().map { it.toResponse() }

    fun findById(id: Long): TrainerResponse =
        trainerRepository.findById(id)
            .orElseThrow { NoSuchElementException("Trainer not found with id: $id") }
            .toResponse()

    fun findByRole(role: String): List<TrainerResponse> {
        val trainerRole = try {
            TrainerRole.valueOf(role.uppercase())
        } catch (e: IllegalArgumentException) {
            throw IllegalArgumentException("Invalid role '$role'. Valid values: NUTRITIONIST, PERSONAL_TRAINER")
        }
        return trainerRepository.findByRole(trainerRole).map { it.toResponse() }
    }

    private fun Trainer.toResponse() = TrainerResponse(
        id = id,
        firstName = firstName,
        lastName = lastName,
        role = role.name,
        bio = bio,
        email = email,
        createdAt = createdAt
    )
}
