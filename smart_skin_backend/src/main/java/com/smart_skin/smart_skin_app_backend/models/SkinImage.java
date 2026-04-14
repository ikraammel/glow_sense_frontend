package com.smart_skin.smart_skin_app_backend.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class SkinImage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
    private String imageUrl;
    private LocalDate dateCaptured;

    @OneToMany(mappedBy = "skinImage", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<SkinAnalysis> skinAnalyses;
}
