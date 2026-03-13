// type GFJ04 and then press control+space to trigger suggestions of snippets 
import { IInputs, IOutputs } from "./generated/ManifestTypes";

export class QuantityIndicator
    implements ComponentFramework.StandardControl<IInputs, IOutputs>
{
    private _container: HTMLDivElement;
    private _input: HTMLInputElement;
    private _badge: HTMLSpanElement;
    private _badgeIcon: HTMLSpanElement;
    private _value: number | null;
    private _notifyOutputChanged: () => void;

    constructor() {
        // noop
    }

    public init(
        context: ComponentFramework.Context<IInputs>,
        notifyOutputChanged: () => void,
        _state: ComponentFramework.Dictionary,
        container: HTMLDivElement
    ): void {
        this._notifyOutputChanged = notifyOutputChanged;
        this._container = container;

        const wrapper = document.createElement("div");
        wrapper.classList.add("quantity-badge-wrapper");

        // Editable input
        this._input = document.createElement("input");
        this._input.type = "number";
        this._input.classList.add("quantity-badge__input");
        this._input.addEventListener("change", this._onInputChange.bind(this));
        this._input.addEventListener("input", this._onInputLive.bind(this));

        // Color badge icon
        this._badgeIcon = document.createElement("span");
        this._badgeIcon.classList.add("quantity-badge__icon");

        // Color badge
        this._badge = document.createElement("span");
        this._badge.classList.add("quantity-badge");

        wrapper.appendChild(this._input);
        wrapper.appendChild(this._badge);
        this._container.appendChild(wrapper);

        this._setValue(context.parameters.quantity.raw);
    }

    public updateView(context: ComponentFramework.Context<IInputs>): void {
        const incoming = context.parameters.quantity.raw;
        if (incoming !== this._value) {
            this._setValue(incoming);
        }

        // Respect disabled state from the form
        const isDisabled = context.mode.isControlDisabled;
        this._input.disabled = isDisabled;
        if (isDisabled) {
            this._input.classList.add("quantity-badge__input--disabled");
        } else {
            this._input.classList.remove("quantity-badge__input--disabled");
        }
    }

    public getOutputs(): IOutputs {
        return { quantity: this._value ?? undefined };
    }

    public destroy(): void {
        // noop
    }

    private _onInputChange(): void {
        const parsed = parseInt(this._input.value, 10);
        this._value = isNaN(parsed) ? null : parsed;
        this._updateBadge(this._value);
        this._notifyOutputChanged();
    }

    private _onInputLive(): void {
        const parsed = parseInt(this._input.value, 10);
        this._updateBadge(isNaN(parsed) ? null : parsed);
    }

    private _setValue(raw: number | null): void {
        this._value = raw;
        this._input.value = raw != null ? raw.toString() : "";
        this._updateBadge(raw);
    }

    private _updateBadge(val: number | null): void {
        const tier = this._getTier(val);
        this._badge.className = "quantity-badge";
        this._badge.classList.add(`quantity-badge--${tier.color}`);
        this._badge.textContent = tier.icon;
    }

    private _getTier(val: number | null): { color: string; icon: string } {
        if (val == null || val <= 0) return { color: "red", icon: "\u26A0" };
        if (val <= 2) return { color: "yellow", icon: "\u25CF" };
        return { color: "green", icon: "\u2714" };
    }
}