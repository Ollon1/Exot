<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

function isAdmin()
{
    return isset($_SESSION['user_id']) && $_SESSION['is_admin'];
}

function getUserRole()
{
    return $_SESSION['admin_role'] ?? null;
}

function requireAdmin()
{
    if (!isAdmin()) {
        http_response_code(403);
        echo json_encode(['error' => 'Access denied']);
        exit;
    }
}

/**
 * Checks if the user is an admin and has the given role.
 * If the condition is not met, it sends a 403 response with an "Access denied" error message.
 *
 * @param string $requiredRole The required role.
 */
function requireAdminRole($requiredRole)
{
    if (!isAdmin() || getUserRole() !== $requiredRole) {
        http_response_code(403);
        echo json_encode(['error' => 'Access denied']);
        exit;
    }
}
