package com.smart_skin.smart_skin_app_backend.models;

import com.smart_skin.smart_skin_app_backend.enums.Severity;
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
public class SkinAnalysis {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long imageId;
    private List<String> detectedProblems;
    @Enumerated(EnumType.STRING)
    private Severity severity;
    private LocalDate analysisDate;

    @ManyToOne
    @JoinColumn(name = "skin_image_id")
    private SkinImage skinImage;

    @OneToMany(mappedBy = "skinAnalysis", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<SkinProblem> skinProblems;

    @OneToMany(mappedBy = "skinAnalysis", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<SkinReport> skinReports;
}
