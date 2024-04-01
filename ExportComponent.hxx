#pragma once

#include <cppuhelper/implementationentry.hxx>
#include <cppuhelper/weak.hxx>

#include <array>

namespace ExportComponent {
    namespace details {

        template<typename T>
        concept Exportable =  requires {
                                            static_cast<cppu::OWeakObject*>(std::declval<T*>());
                                            T::getImplementationName;
                                            T::getSupportedServiceNames;
                                        };

        template<Exportable component>
        css::uno::Reference<css::uno::XInterface> componentFactory(const css::uno::Reference<css::uno::XComponentContext>& rContext) {
            return static_cast<cppu::OWeakObject*>(new component(rContext));
        }

        template<Exportable component>
        cppu::ImplementationEntry makeImplementationEntry() {
            return cppu::ImplementationEntry {componentFactory<component>,
                                                component::getImplementationName,
                                                component::getSupportedServiceNames,
                                                cppu::createOneInstanceComponentFactory,
                                                nullptr,
                                                0};
        }


    } // namespace details
        
    template<details::Exportable... Args>
    std::array<cppu::ImplementationEntry, sizeof...(Args) + 1> makeImplementationEntryArray() {
        return {details::makeImplementationEntry<Args>()...};
    }

} // namespace ExportComponent