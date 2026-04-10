package com.clinica.service

import com.clinica.domain.TrainingPlan
import com.clinica.dto.TrainingPlanRequest
import com.clinica.dto.TrainingPlanResponse
import com.clinica.repository.ClientRepository
import com.clinica.repository.TrainerRepository
import com.clinica.repository.TrainingPlanRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class TrainingPlanService(
    private val trainingPlanRepository: TrainingPlanRepository,
    private val clientRepository: ClientRepository,
    private val trainerRepository: TrainerRepository
) {

    @Transactional(readOnly = true)
    fun findAll(clientId: Long?): List<TrainingPlanResponse> {
        val list = if (clientId != null) trainingPlanRepository.findByClientId(clientId)
                   else trainingPlanRepository.findAll()
        return list.map { it.toResponse() }
    }

    @Transactional(readOnly = true)
    fun findById(id: Long): TrainingPlanResponse =
        trainingPlanRepository.findById(id)
            .orElseThrow { NoSuchElementException("Training plan not found with id: $id") }
            .toResponse()

    fun create(request: TrainingPlanRequest): TrainingPlanResponse {
        val client = clientRepository.findById(request.clientId)
            .orElseThrow { NoSuchElementException("Client not found with id: ${request.clientId}") }
        val trainer = trainerRepository.findById(request.trainerId)
            .orElseThrow { NoSuchElementException("Trainer not found with id: ${request.trainerId}") }

        val plan = TrainingPlan(
            client = client,
            trainer = trainer,
            title = request.title,
            description = request.description,
            weeks = request.weeks,
            sessionsPerWeek = request.sessionsPerWeek,
            active = request.active
        )
        return trainingPlanRepository.save(plan).toResponse()
    }

    fun update(id: Long, request: TrainingPlanRequest): TrainingPlanResponse {
        val plan = trainingPlanRepository.findById(id)
            .orElseThrow { NoSuchElementException("Training plan not found with id: $id") }

        plan.title = request.title
        plan.description = request.description
        plan.weeks = request.weeks
        plan.sessionsPerWeek = request.sessionsPerWeek
        plan.active = request.active

        return trainingPlanRepository.save(plan).toResponse()
    }

    fun delete(id: Long) {
        if (!trainingPlanRepository.existsById(id))
            throw NoSuchElementException("Training plan not found with id: $id")
        trainingPlanRepository.deleteById(id)
    }

    private fun TrainingPlan.toResponse() = TrainingPlanResponse(
        id = id,
        clientId = client.id,
        clientFullName = "${client.firstName} ${client.lastName}",
        trainerId = trainer.id,
        trainerFullName = "${trainer.firstName} ${trainer.lastName}",
        title = title,
        description = description,
        weeks = weeks,
        sessionsPerWeek = sessionsPerWeek,
        active = active,
        createdAt = createdAt
    )
}
