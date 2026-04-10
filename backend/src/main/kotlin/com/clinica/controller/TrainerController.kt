package com.clinica.controller

import com.clinica.dto.TrainerResponse
import com.clinica.service.TrainerService
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/trainers")
@Tag(name = "Trainers", description = "Simona (Nutritionist) and Luca (Personal Trainer)")
class TrainerController(private val trainerService: TrainerService) {

    @GetMapping
    @Operation(summary = "List all trainers", description = "Optionally filter by role: NUTRITIONIST or PERSONAL_TRAINER")
    fun findAll(@RequestParam(required = false) role: String?): List<TrainerResponse> =
        if (!role.isNullOrBlank()) trainerService.findByRole(role)
        else trainerService.findAll()

    @GetMapping("/{id}")
    @Operation(summary = "Get trainer by ID")
    fun findById(@PathVariable id: Long): TrainerResponse =
        trainerService.findById(id)
}
