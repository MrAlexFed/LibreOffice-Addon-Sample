#include "ExportComponent.hxx"

#include "DispatchProvider.hxx"

#include <uno/lbnames.h>

namespace {
   const auto&& components = ExportComponent::makeImplementationEntryArray<DispatchProvider>();

}


extern "C" {
    
SAL_DLLPUBLIC_EXPORT void* SAL_CALL component_getFactory(const char* pImplName, void* pServiceManager, void* pRegistryKey) {
    return cppu::component_getFactoryHelper(pImplName, pServiceManager, pRegistryKey, components.data());

}

SAL_DLLPUBLIC_EXPORT void SAL_CALL component_getImplementationEnvironment(const char** ppEnvTypeName, uno_Environment**) {
    *ppEnvTypeName = CPPU_CURRENT_LANGUAGE_BINDING_NAME;
}

SAL_DLLPUBLIC_EXPORT sal_Bool SAL_CALL component_writeInfo(void* xMgr, void* xRegistry) {
    return cppu::component_writeInfoHelper(xMgr, xRegistry, components.data());
}

} // extern C