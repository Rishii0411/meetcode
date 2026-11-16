package com.rishabh.meetcode.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.util.HashSet;
import java.util.Set;

@Entity
@Getter
@Setter
@NoArgsConstructor
public class Problem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String title;
    @Column(columnDefinition = "TEXT")
    private String description;
    private String difficulty;
    @Column(columnDefinition = "TEXT")
    private String examples;
    @Column(columnDefinition = "TEXT")
    private String constraints;
    @ManyToMany
    @JoinTable( name = "problem_tags",
                joinColumns = @JoinColumn(name = "problem_id"),
                inverseJoinColumns = @JoinColumn(name = "tag_id")
              )
    private Set<Tag> tags = new HashSet<>();

    @OneToMany(mappedBy = "problem")
    private Set<TestCases> testCases = new HashSet<>();

    @Column(columnDefinition = "TEXT")
    private String harnessTemplate;

    private String methodName;

    private String returnType;

    private String category;

    @Column(columnDefinition = "TEXT")
    private String parameterDefinitions;

    @Column(nullable = false)
    private boolean active = true;

    @Column(nullable = false)
    private boolean deleted = false;

    @Column(columnDefinition = "TEXT")
    private String referenceSolution;


    @ManyToMany
    @JoinTable(
            name = "problem_companies",
            joinColumns = @JoinColumn(name = "problem_id"),
            inverseJoinColumns = @JoinColumn(name = "company_id")
    )
    private Set<Company> companies = new HashSet<>();

}
