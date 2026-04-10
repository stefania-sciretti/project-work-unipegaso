package com.clinica.service

import com.clinica.domain.Recipe
import com.clinica.dto.RecipeRequest
import com.clinica.dto.RecipeResponse
import com.clinica.repository.RecipeRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class RecipeService(private val recipeRepository: RecipeRepository) {

    @Transactional(readOnly = true)
    fun findAll(category: String?, search: String?): List<RecipeResponse> {
        val list = when {
            !category.isNullOrBlank() -> recipeRepository.findByCategoryIgnoreCase(category)
            !search.isNullOrBlank() -> recipeRepository.findByTitleContainingIgnoreCase(search)
            else -> recipeRepository.findAll()
        }
        return list.map { it.toResponse() }
    }

    @Transactional(readOnly = true)
    fun findById(id: Long): RecipeResponse =
        recipeRepository.findById(id)
            .orElseThrow { NoSuchElementException("Recipe not found with id: $id") }
            .toResponse()

    fun create(request: RecipeRequest): RecipeResponse {
        val recipe = Recipe(
            title = request.title,
            description = request.description,
            ingredients = request.ingredients,
            instructions = request.instructions,
            calories = request.calories,
            category = request.category
        )
        return recipeRepository.save(recipe).toResponse()
    }

    fun update(id: Long, request: RecipeRequest): RecipeResponse {
        val recipe = recipeRepository.findById(id)
            .orElseThrow { NoSuchElementException("Recipe not found with id: $id") }

        recipe.title = request.title
        recipe.description = request.description
        recipe.ingredients = request.ingredients
        recipe.instructions = request.instructions
        recipe.calories = request.calories
        recipe.category = request.category

        return recipeRepository.save(recipe).toResponse()
    }

    fun delete(id: Long) {
        if (!recipeRepository.existsById(id))
            throw NoSuchElementException("Recipe not found with id: $id")
        recipeRepository.deleteById(id)
    }

    private fun Recipe.toResponse() = RecipeResponse(
        id = id,
        title = title,
        description = description,
        ingredients = ingredients,
        instructions = instructions,
        calories = calories,
        category = category,
        createdAt = createdAt
    )
}
