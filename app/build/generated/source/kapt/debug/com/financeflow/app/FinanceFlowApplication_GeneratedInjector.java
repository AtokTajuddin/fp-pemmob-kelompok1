package com.financeflow.app;

import dagger.hilt.InstallIn;
import dagger.hilt.codegen.OriginatingElement;
import dagger.hilt.components.SingletonComponent;
import dagger.hilt.internal.GeneratedEntryPoint;

@OriginatingElement(
    topLevelClass = FinanceFlowApplication.class
)
@GeneratedEntryPoint
@InstallIn(SingletonComponent.class)
public interface FinanceFlowApplication_GeneratedInjector {
  void injectFinanceFlowApplication(FinanceFlowApplication financeFlowApplication);
}
