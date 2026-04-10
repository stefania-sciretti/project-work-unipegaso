package com.clinica.service

import com.clinica.domain.Client
import com.clinica.dto.ClientRequest
import com.clinica.dto.ClientResponse
import com.clinica.repository.ClientRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class ClientService(private val clientRepository: ClientRepository) {

    @Transactional(readOnly = true)
    fun findAll(): List<ClientResponse> =
        clientRepository.findAll().map { it.toResponse() }

    @Transactional(readOnly = true)
    fun findById(id: Long): ClientResponse =
        clientRepository.findById(id)
            .orElseThrow { NoSuchElementException("Client not found with id: $id") }
            .toResponse()

    @Transactional(readOnly = true)
    fun search(query: String): List<ClientResponse> =
        clientRepository
            .findByLastNameContainingIgnoreCaseOrFirstNameContainingIgnoreCase(query, query)
            .map { it.toResponse() }

    fun create(request: ClientRequest): ClientResponse {
        if (clientRepository.existsByEmail(request.email)) {
            throw IllegalArgumentException("A client with email '${request.email}' already exists")
        }
        val client = Client(
            firstName = request.firstName,
            lastName = request.lastName,
            email = request.email,
            phone = request.phone,
            birthDate = request.birthDate,
            goal = request.goal
        )
        return clientRepository.save(client).toResponse()
    }

    fun update(id: Long, request: ClientRequest): ClientResponse {
        val client = clientRepository.findById(id)
            .orElseThrow { NoSuchElementException("Client not found with id: $id") }

        client.firstName = request.firstName
        client.lastName = request.lastName
        client.email = request.email
        client.phone = request.phone
        client.birthDate = request.birthDate
        client.goal = request.goal

        return clientRepository.save(client).toResponse()
    }

    fun delete(id: Long) {
        if (!clientRepository.existsById(id)) {
            throw NoSuchElementException("Client not found with id: $id")
        }
        clientRepository.deleteById(id)
    }

    private fun Client.toResponse() = ClientResponse(
        id = id,
        firstName = firstName,
        lastName = lastName,
        email = email,
        phone = phone,
        birthDate = birthDate,
        goal = goal,
        createdAt = createdAt
    )
}
