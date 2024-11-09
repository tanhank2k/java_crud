package io.bootify.crud_app.repos;

import io.bootify.crud_app.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;


public interface UserRepository extends JpaRepository<User, Long> {
}
