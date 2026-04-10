package com.clinica.service

import com.clinica.domain.DietPlan
import com.clinica.dto.DietPlanRequest
import com.clinica.dto.DietPlanResponse
import com.clinica.repository.ClientRepository
import com.clinica.repository.DietPlanRepository
import com.clinica.repository.TrainerRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class DietPlanService(
    private val dietPlanRepository: DietPlanRepository,
    private val clientRepository: ClientRepository,
    private val trainerRepository: TrainerRepository
) {

    @Transactional(readOnly = true)
    fun findAll(clientId: Long?): List<DietPlanResponse> {
        val list = if (clientId != null) dietPlanRepository.findByClientId(clientId)
                   else dietPlanRepository.findAll()
        return list.map { it.toResponse() }
    }

    @Transactional(readOnly = true)
    fun findById(id: Long): DietPlanResponse =
        dietPlanRepository.findById(id)
            .orElseThrow { NoSuchElementException("Diet plan not found with id: $id") }
            .toResponse()

    fun create(request: DietPlanRequest): DietPlanResponse {
        val client = clientRepository.findById(request.clientId)
            .orElseThrow { NoSuchElementException("Client not found with id: ${request.clientId}") }
        val trainer = trainerRepository.findById(request.trainerId)
            .orElseThrow { NoSuchElementException("Trainer not found with id: ${request.trainerId}") }

        val plan = DietPlan(
            client = client,
            trainer = trainer,
            title = request.title,
            description = request.description,
            calories = request.calories,
            durationWeeks = request.durationWeeks,
            active = request.active
        )
        return dietPlanRepository.save(plan).toResponse()
    }

    fun update(id: Long, request: DietPlanRequest): DietPlanResponse {
        val plan = dietPlanRepository.findById(id)
            .orElseThrow { NoSuchElementException("Diet plan not found with id: $id") }

        plan.title = request.title
        plan.description = request.description
        plan.calories = request.calories
        plan.durationWeeks = request.durationWeeks
        plan.active = request.active

        return dietPlanRepository.save(plan).toResponse()
    }

    fun delete(id: Long) {
        if (!dietPlanRepository.existsById(id))
            throw NoSuchElementException("Diet plan not found with id: $id")
        dietPlanRepository.deleteById(id)
    }

    private fun DietPlan.toResponse() = DietPlanResponse(
        id = id,
        clientId = client.id,
        clientFullName = "${client.firstName} ${client.lastName}",
        trainerId = trainer.id,
        trainerFullName = "${trainer.firstName} ${trainer.lastName}",
        title = title,
        description = description,
        calories = calories,
        durationWeeks = durationWeeks,
        active = active,
        createdAt = createdAt
    )
}
