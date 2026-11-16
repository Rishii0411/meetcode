
package com.rishabh.meetcode.config;

import com.rishabh.meetcode.service.UserService;
import jakarta.servlet.DispatcherType;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http)
            throws Exception {

        http
                .authorizeHttpRequests(auth -> auth

                        .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()

                        .requestMatchers(
                                "/",
                                "/register",
                                "/login",
                                "/css/**",
                                "/js/**",
                                "/**/*.png",
                                "/**/*.jpg",
                                "/**/*.jpeg",
                                "/**/*.gif",
                                "/**/*.svg",
                                "/**/*.webp",
                                "/favicon.ico",
                                "/.well-known/appspecific/com.chrome.devtools.json"
                        ).permitAll()

                        .requestMatchers(
                                HttpMethod.GET,
                                "/addproblem"
                        ).hasRole("ADMIN")

                        .requestMatchers(
                                HttpMethod.POST,
                                "/addproblem"
                        ).hasRole("ADMIN")

                        .requestMatchers(
                                HttpMethod.GET,
                                "/problems/**"
                        ).permitAll()

                        .requestMatchers(
                                HttpMethod.POST,
                                "/problems/*/run"
                        ).permitAll()

                        .requestMatchers(
                                HttpMethod.POST,
                                "/problems/*/submit"
                        ).authenticated()

                        .requestMatchers(
                                HttpMethod.GET,
                                "/problems/*/submissions"
                        ).authenticated()

                        .requestMatchers(
                                HttpMethod.GET,
                                "/problems/*/submissions/*"
                        ).authenticated()

                        .requestMatchers(HttpMethod.POST, "/deleteproblem/**").hasRole("ADMIN")

                        .requestMatchers("/admin/**").hasRole("ADMIN")

                        .anyRequest().authenticated()
                )

                .formLogin(form -> form
                        .loginPage("/login")
                        .permitAll()
                )

                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout")
                        .permitAll()
                )

                .authenticationProvider(authenticationProvider());

        return http.build();
    }

    @Bean
    public AuthenticationProvider authenticationProvider() {

        DaoAuthenticationProvider provider =
                new DaoAuthenticationProvider(userService);

        provider.setPasswordEncoder(passwordEncoder);

        return provider;
    }
}
