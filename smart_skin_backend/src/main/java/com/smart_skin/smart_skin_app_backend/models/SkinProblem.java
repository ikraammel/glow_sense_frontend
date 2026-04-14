package com.smart_skin.smart_skin_app_backend.models;

import com.smart_skin.smart_skin_app_backend.enums.Severity;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class SkinProblem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String description;
    private String problemType;
    @Enumerated(EnumType.STRING)
    private Severity severity;

    @ManyToOne
    @JoinColumn(name = "skin_analysis_id")
    private SkinAnalysis skinAnalysis;
}
